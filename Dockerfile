FROM denoland/deno:2.3.5

WORKDIR config

COPY . .

CMD ["bash"]
