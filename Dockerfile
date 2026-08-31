FROM denoland/deno:2.9.6

WORKDIR config

COPY . .

CMD ["bash"]
