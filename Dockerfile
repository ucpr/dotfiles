FROM denoland/deno:2.4.5

WORKDIR config

COPY . .

CMD ["bash"]
