FROM denoland/deno:2.6.5

WORKDIR config

COPY . .

CMD ["bash"]
